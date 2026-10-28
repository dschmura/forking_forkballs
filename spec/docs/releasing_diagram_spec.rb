require "rails_helper"
require "nokogiri"

RSpec.describe "The releasing guide's flow diagram" do
  let(:source) { Rails.root.join("app/docs/developer/releasing.md").read }
  let(:svg) { source[/<svg\b.*?<\/svg>/m] }

  it "is well-formed and named for assistive tech" do
    root = Nokogiri::XML(svg) { |config| config.strict }.root

    expect(root["role"]).to eq("img")
    expect(root["aria-label"]).to include("next").and include("staging").and include("production")
  end

  it "survives the markdowndocs renderer with every stage drawn inside it" do
    rendered = Nokogiri::HTML5.fragment(Markdowndocs::MarkdownRenderer.render(source.sub(/\A---\n.*?\n---\n/m, "")))
    drawn = rendered.at_css("svg")

    expect(drawn.at_css("marker#arrow-release")).to be_present
    expect(drawn.css("text").map(&:text)).to include("your branch", "next", "release/<name>", "main")
    expect(rendered.css("rect, path, line").reject { |node| node.ancestors("svg").any? }).to be_empty
  end
end

require "rails_helper"
require "nokogiri"

RSpec.describe "The releasing guide's flow diagram" do
  let(:source) { Rails.root.join("app/docs/developer/releasing.md").read }
  let(:svgs) { source.scan(/<svg\b.*?<\/svg>/m).map { |svg| Nokogiri::XML(svg) { |config| config.strict }.root } }
  let(:wide) { svgs.find { |svg| svg["class"].to_s.split.include?("md:block") } }
  let(:narrow) { svgs.find { |svg| svg["class"].to_s.split.include?("md:hidden") } }
  let(:smallest_phone_width) { 264 }

  it "draws a wide version from tablet width up and a narrow one below it" do
    expect(svgs.size).to eq(2)
    expect(wide["class"].split).to include("hidden")
    expect(narrow["class"].split).to include("max-w-xs")
  end

  it "names both versions for assistive tech" do
    svgs.each do |svg|
      expect(svg["role"]).to eq("img")
      expect(svg["aria-label"]).to include("next").and include("staging").and include("production")
    end
  end

  it "heads each stop with its branch, with the book analogy beneath it" do
    svgs.each do |svg|
      headings = svg.css('text[font-weight="700"]').map(&:text)

      expect(headings).to include("your branch", "next", "release/<name>", "main")
      expect(headings).not_to include("The draft", "The pile", "The book", "Published")
    end
  end

  it "sets the narrow version's words at 12px or more on a 360px phone" do
    scale = smallest_phone_width / narrow["viewBox"].split[2].to_f

    narrow.css("text").each do |text|
      group_scale = text.ancestors("g").map { |g| g["transform"].to_s[/scale\(([\d.]+)\)/, 1]&.to_f || 1 }.reduce(1, :*)
      rendered = text["font-size"].to_f * group_scale * scale
      expect(rendered).to be >= 12, "#{text.text.inspect} renders at #{rendered.round(1)}px"
    end
  end

  it "survives the markdowndocs renderer with every stage drawn in each version" do
    rendered = Nokogiri::HTML5.fragment(Markdowndocs::MarkdownRenderer.render(source.sub(/\A---\n.*?\n---\n/m, "")))
    drawn = rendered.css("svg")

    expect(drawn.size).to eq(2)
    expect(drawn.flat_map { |svg| svg.css("marker").map { |marker| marker["id"] } }.uniq.size).to eq(2)
    drawn.each do |svg|
      expect(svg.css("text").map(&:text)).to include("your branch", "next", "release/<name>", "main")
    end
    expect(rendered.css("rect, path, line").reject { |node| node.ancestors("svg").any? }).to be_empty
  end
end

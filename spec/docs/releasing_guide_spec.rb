require "rails_helper"
require "nokogiri"

RSpec.describe "The releasing guide" do
  let(:source) { Rails.root.join("app/docs/developer/releasing.md").read }
  let(:rendered) { Nokogiri::HTML5.fragment(Markdowndocs::MarkdownRenderer.render(source.sub(/\A---\n.*?\n---\n/m, ""))) }
  let(:before_it_merges) { source[/^## Before it merges\n.*?(?=^## )/m] }

  it "sends every in-page link to a heading that exists" do
    ids = rendered.css("[id]").map { |node| node["id"] }

    rendered.css('a[href^="#"]').each do |link|
      expect(ids).to include(link["href"].delete_prefix("#")), "#{link["href"]} has no heading"
    end
  end

  it "asks for the PR's changelog line before it merges, not only at release time" do
    expect(before_it_merges).to include("[Unreleased]")
  end

  it "shows how to hold back a squash-merged PR as well as a merged one" do
    expect(source).to include("git revert -m 1 <the feature's merge commit>").and include("git revert <its squash commit>")
  end

  it "says what a hotfix ships without: a tag" do
    expect(source[/^## Hotfix\n.*?(?=^## )/m]).to match(/untagged/)
  end

  it "gives commands that run as written, with no placeholder for the repository" do
    expect(source).not_to include("OWNER/REPO")
  end
end

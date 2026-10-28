require "rails_helper"

RSpec.describe "the pull request template" do
  let(:template) { Rails.root.join(".github/PULL_REQUEST_TEMPLATE.md").read }
  let(:guide) { Rails.root.join("app/docs/developer/releasing.md").read }

  it "asks which unreleased PRs this one depends on, so they come out of a release together" do
    expect(template).to include("Depends on")
  end

  it "asks for what the specs can't show, written as steps a reviewer can follow on staging" do
    expect(template).to include("## What the specs can't show")
    expect(guide).to include("What the specs can't show")
  end

  it "asks the author to keep the PR removable from a release" do
    expect(template).to match(/removable/i)
    expect(guide).to include("## Keep each PR removable")
  end

  it "keeps the guide asking for one story per PR, so each is easy to check and to pull out" do
    expect(guide).to include("**One story per PR.**")
  end
end

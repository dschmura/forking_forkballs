require "rails_helper"
require "yaml"

RSpec.describe "the next-release workflow" do
  let(:workflow) { YAML.safe_load_file(Rails.root.join(".github/workflows/next_release.yml"), aliases: true) }
  let(:triggers) { workflow[true] || workflow["on"] }
  let(:prepare) { workflow.dig("jobs", "prepare") }
  let(:cut) { workflow.dig("jobs", "cut") }
  let(:release_steps) { [ prepare, cut ].flat_map { |job| job["steps"] }.select { |step| step["run"].to_s.include?("bin/release") } }

  it "runs only when a pull request into next closes" do
    expect(triggers.keys).to eq([ "pull_request" ])
    expect(triggers["pull_request"]).to eq("types" => [ "closed" ], "branches" => [ "next" ])
  end

  it "stays off until the AUTO_RELEASE repository variable says true" do
    expect([ prepare["if"], cut["if"] ]).to all(include("vars.AUTO_RELEASE == 'true'"))
  end

  it "acts only on merged pull requests from this repository's own branches" do
    expect([ prepare["if"], cut["if"] ]).to all(include("github.event.pull_request.merged"))
    expect([ prepare["if"], cut["if"] ]).to all(include("github.event.pull_request.head.repo.full_name == github.repository"))
  end

  it "names the next release when a release's merge-back merges, not a hotfix's" do
    expect(prepare["if"]).to include("startsWith(github.event.pull_request.head.ref, 'merge-back/')")
    expect(prepare["if"]).to include("!startsWith(github.event.pull_request.head.ref, 'merge-back/main-')")
    expect(release_steps.first["run"]).to include("bin/release prepare --skip-if-empty")
  end

  it "cuts the release once its changelog PR merges" do
    expect(cut["if"]).to include("startsWith(github.event.pull_request.head.ref, 'changelog/')")
    expect(release_steps.last["run"]).to include("bin/release cut")
  end

  it "pushes and opens PRs with RELEASE_TOKEN, since GitHub runs no checks on PRs the built-in token opens" do
    expect(release_steps.map { |step| step.dig("env", "GH_TOKEN") }).to all(eq("${{ secrets.RELEASE_TOKEN }}"))
  end

  it "never runs two release steps at once" do
    expect(workflow.dig("concurrency", "cancel-in-progress")).to be(false)
  end
end

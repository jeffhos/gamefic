require "gamefic/html"
include Gamefic

describe Html do
  it "fixes bare ampersands" do
    code = "&ldquo;One & two &amp; three, let's go to the A&P&rdquo;"
    expect(Html.fix_ampersands(code)).to eq("&ldquo;One &amp; two &amp; three, let's go to the A&amp;P&rdquo;")
  end
  it "fixes invalid < characters" do
    code = "<span>1 < 2</span>"
    expect(Html.parse(code).to_s).to eq("<span>1 &lt; 2</span>")
  end
end

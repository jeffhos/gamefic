require 'gamefic-sdk'
require 'tmpdir'

describe "Restaurant (Web)", :type => :feature, :js => true do
  before :each do
    @dir = Dir.mktmpdir
  end
  after :each do
    FileUtils.remove_entry @dir
  end
  it "concludes web game with test me" do
    config = { 'target_dir' => "#{@dir}/release", 'build_dir' => "#{@dir}/build" }
    web = Gamefic::Sdk::Platform::Web.new("examples/restaurant", config)
    web.build
    visit("#{@dir}/release/index.html")
    sleep(0.1) while page.evaluate_script("$('#gamefic_controls').hasClass('working')")
    fill_in 'command', :with => 'test me'
    click_button 'gamefic_submit'
    sleep(0.1) while page.evaluate_script("$('#gamefic_controls').hasClass('working')")
    expect(page.evaluate_script("$('#gamefic_console').hasClass('concluded')")).to eq(true)
  end
end

require 'gamefic-sdk'

describe "Cloak of Darkness" do
  it "concludes with test me" do
    plot = Plot.new(Source::File.new('examples/cloak_of_darkness/scripts', Gamefic::Sdk::GLOBAL_SCRIPT_PATH))
    plot.script 'main'
    character = plot.make Character, :name => 'player'
    plot.introduce character
    character.perform "test me"
    character[:test_queue].length.times do |actor|
      plot.ready
      character.queue.push character[:test_queue].shift
      plot.update
    end
    expect(plot.scenes[character.scene].class).to eq(Scene::Conclusion)
  end
end

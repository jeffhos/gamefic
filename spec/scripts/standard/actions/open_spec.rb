describe "Open Action" do
  it "opens a closed container" do
    plot = Plot.new(Source::File.new(Gamefic::Sdk::GLOBAL_IMPORT_PATH))
    plot.script 'standard'
    room = plot.make Room, :name => 'room'
    container = plot.make Container, :name => 'container', :parent => room
    container.open = false
    character = plot.make Character, :name => 'character', :parent => room
    character.perform "open container"
    expect(container.open?).to eq(true)
  end
  it "does not open a locked container" do
    plot = Plot.new(Source::File.new(Gamefic::Sdk::GLOBAL_IMPORT_PATH))
    plot.script 'standard'
    room = plot.make Room, :name => 'room'
    container = plot.make Container, :name => 'container', :parent => room
    container.open = false
    container.locked = true
    character = plot.make Character, :name => 'character', :parent => room
    character.perform "open container"
    expect(container.open?).to eq(false)
  end
end

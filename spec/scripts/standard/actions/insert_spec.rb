describe "Insert Action" do
  before :each do
    @plot = Plot.new(Source::File.new(Gamefic::Sdk::GLOBAL_IMPORT_PATH))
    @plot.script 'standard'
    @room = @plot.make Room, :name => 'room'
    @character = @plot.make Character, :name => 'character', :parent => @room
    @item = @plot.make Item, :name => 'item', :parent => @character
    @thing = @plot.make Entity, :name => 'thing', :parent => @character
    @receptacle = @plot.make Receptacle, :name => 'receptacle', :parent => @room
    @container = @plot.make Container, :name => 'container', :parent => @room
    @entity = @plot.make Entity, :name => 'entity', :parent => @room
  end
  it "inserts an item into a receptacle" do
    @character.perform 'insert item in receptacle'
    expect(@item.parent).to be(@receptacle)
  end
  it "inserts an item into an open container" do
    @container.open = true
    @character.perform 'insert item in container'
    expect(@item.parent).to be(@container)
  end
  it "does not insert an item into a closed container" do
    @container.open = false
    @character.perform 'insert item in container'
    expect(@item.parent).to be(@character)
  end
  it "does not insert an item into a generic entity" do
    @character.perform 'insert item in entity'
    expect(@item.parent).to be(@character)
  end
end

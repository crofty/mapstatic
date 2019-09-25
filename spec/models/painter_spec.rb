require 'spec_helper'

describe Mapstatic::Painter do
  it "should not accept any geometry type" do
    expect(Mapstatic::Painter.accept? "LineString").to be(false)
  end
end

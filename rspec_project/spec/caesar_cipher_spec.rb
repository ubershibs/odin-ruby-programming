require 'spec_helper'

RSpec.describe "caesar_cipher" do

  it "shifts each letter by a given integer" do
    expect(caesar_cipher("hello", 5)).to eq("mjqqt")
  end

  it "fails when shift is more or less than 25" do
    expect(caesar_cipher("hello", 300)).to eq("Shift must be between 1-25")
  end

  it "wraps if shift forces characters to go past z" do
    expect(caesar_cipher("hello", 25)).to eq("gdkkn") 
  end

  it "handles negative shifts" do
    expect(caesar_cipher("hello", -1)).to eq("gdkkn") 
  end

  it "respects capitalization" do
    expect(caesar_cipher("HeLlo", 25)).to eq("GdKkn") 
  end

  it "does not shift non-alphabet characters" do
    expect(caesar_cipher("Hello! 1234", 25)).to eq("Gdkkn! 1234")
  end

  it "raises an error when 0 or 1 arguments are given" do
    expect {caesar_cipher()}.to raise_error(ArgumentError)
    expect {caesar_cipher(1)}.to raise_error(ArgumentError)
  end
end 

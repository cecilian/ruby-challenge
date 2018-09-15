require_relative '../level2/main.rb'

describe 'Main' do
  let(:tractus) { Tractus.new "level2/data.json" }

  it 'produces the right output given the input' do
    expect(tractus.to_json).to eq JSON.parse(File.read("level2/output.json")).to_json
  end
end

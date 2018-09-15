require_relative '../../level3/main.rb'

describe 'Main' do
  let(:tractus) { Tractus.new "level3/files/data.json" }

  it 'produces the right output given the input' do
    expect(tractus.to_json).to eq JSON.parse(File.read("level3/files/output.json")).to_json
  end
end

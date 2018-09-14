require_relative '../level1/main.rb'

describe 'Main' do
  it 'produces the right output given the input' do
    expect(Tractus.generate_output("level1/data.json")).to eq JSON.parse(File.read("level1/output.json")).to_json
  end
end

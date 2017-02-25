require "spec_helper"

describe Ixbrl, :requires => 'elasticsearch' do
  it "has a version number" do
    expect(Ixbrl::VERSION).not_to be nil
  end
end
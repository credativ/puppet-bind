require 'spec_helper'

describe 'bind' do
  context "With default facts" do
    it {
      should contain_class('bind')
    }
  end

  context "With valid forward" do
    let (:params) { { :forward => 'only' } }

    it {
      should contain_class('bind')
    }
  end

  context "With invalid forward" do
    let (:params) { { :forward => 'invalid' } }

    it {
      expect { is_expected.to compile }.to raise_error(/.*invalid.*/)
    }
  end
end

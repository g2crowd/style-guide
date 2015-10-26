require 'spec_helper'

describe StyleGuide::Partial do
  let(:path) { '/hygenic/_gargling.erb' }
  let(:section) { StyleGuide::Section.from_paths('/flaky/gangrene').first }
  let(:partial) { StyleGuide::Partial.new(path, section) }

  describe '#title' do
    subject { partial.title }

    context 'with a simple path' do
      it { is_expected.to eq 'Gargling' }
    end

    context 'with a path activerecord would be good at' do
      let(:path) { '/tasty/_tree-leather.erb' }

      it { is_expected.to eq 'Tree Leather' }
    end

    context 'with a path containing extra stuff' do
      let(:path) { '/help/_a!dog%has-m1y=keyb^oaard.erb' }

      it { is_expected.to eq 'A!Dog%Has M1y=Keyb^Oaard' }
    end
  end

  describe '#id' do
    subject { partial.id }

    context 'with a simple path' do
      it { is_expected.to eq 'gargling' }
    end

    context 'with a good activerecord path' do
      let(:path) { '/tasty/_thumb_tacks.erb' }

      it { is_expected.to eq 'thumb_tacks' }
    end

    context 'with a path containing extra stuff' do
      let(:path) { '/help/mugabe%has-m1y=keyb^oaard' }

      it { is_expected.to eq 'mugabe_has_m1y_keyb_oaard' }
    end
  end

  describe '#description' do
    subject { partial.description }

    context 'when no translation string exists' do
      before { allow(I18n).to receive(:translate).and_return(nil) }

      it { is_expected.to be_nil }
    end

    context 'when there is a translation string available' do
      let(:translated) { 'pants' }

      before { allow(I18n).to receive(:translate).and_return(translated) }

      it { should include '<p>pants' }

      context 'when the translated string includes html' do
        let(:translated) { '`<br>`' }

        it { should include '&lt;br&gt;' }
      end

      context 'when the translated string includes markdown' do
        let(:translated) { '`meat` *beans* __socks__' }

        it { should include '<code>meat' }
        it { should include '<em>beans' }
        it { should include '<strong>socks' }
      end
    end
  end

  describe '#classes' do
    let(:content) { '<div class="noseclip"><img class="earplug noseclip"></div>' }

    before { allow(partial).to receive(:render).and_return(content) }

    subject { partial.classes }

    it { is_expected.to match_array %w(.noseclip .earplug) }
  end

  describe '#ids' do
    let(:content) { '<div id="stent"><img id="cholesterol"></div>' }

    before { allow(partial).to receive(:render).and_return(content) }

    subject { partial.ids }

    it { is_expected.to match_array %w(#cholesterol #stent) }
  end

  describe '#identifiers' do
    before do
      allow(partial).to receive(:classes).and_return(%w(.puppies .rainbows))
      allow(partial).to receive(:ids).and_return(%w(#ice-cream #lollipops))
    end

    subject { partial.identifiers }

    it { is_expected.to match_array %w(.puppies .rainbows #ice-cream #lollipops) }
  end

  describe '#render' do
    let(:mock_view) { double(:view, render: 'hi') }

    before { allow(partial).to receive(:action_view).and_return(mock_view) }

    subject { partial.render }

    it { is_expected.to eq 'hi' }
  end
end

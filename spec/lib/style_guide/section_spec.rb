require 'spec_helper'

describe StyleGuide::Section do
  let(:path) { '/magnetic/sputum' }
  let(:section) { StyleGuide::Section.new('sputum', path) }

  describe '.id_from_path' do
    subject { StyleGuide::Section.id_from_path(path) }

    context 'with a simple path' do
      it { is_expected.to eq 'sputum' }
    end

    context 'with a good activerecord path' do
      let(:path) { '/tasty/bicycle_tires' }

      it { is_expected.to eq 'bicycle_tires' }
    end

    context 'with a path containing extra stuff' do
      let(:path) { '/help/kocher%has-m1y=keyb^oaard' }

      it { is_expected.to eq 'kocher_has_m1y_keyb_oaard' }
    end
  end

  describe '.from_paths' do
    let(:paths) { path }
    subject { StyleGuide::Section.from_paths(paths).map(&:id) }

    context 'with a single path' do
      it { is_expected.to eq ['sputum'] }
    end

    context 'with multiple paths' do
      let(:paths) { %w(/bat/wings /thinning/hair) }

      it { is_expected.to match_array %w(wings hair) }
    end

    context 'with multiple paths having the same basename' do
      let(:paths) { %w(/neck/wattle /underarm/wattle) }

      it { is_expected.to match_array %w(wattle wattle1) }
    end
  end

  describe '#title' do
    subject { section.title }

    context 'with a simple path' do
      it { is_expected.to eq 'Sputum' }
    end

    context 'with a path activerecord would be good at' do
      let(:path) { '/tasty/bicycle_tires' }

      it { is_expected.to eq 'Bicycle Tires' }
    end

    context 'with a path containing extra stuff' do
      let(:path) { '/help/kocher%has-m1y=keyb^oaard' }

      it { is_expected.to eq 'Kocher%Has M1y=Keyb^Oaard' }
    end
  end

  describe '#partials' do
    let(:partial_paths) { %w(/corrosive/chapstick /rusty/derringer) }
    subject { section.partials }

    before do
      allow(Dir).to receive(:glob).and_return(partial_paths)
    end

    it { expect(subject.size).to eq 2 }
    it { expect(subject.first).to be_a StyleGuide::Partial }
  end
end

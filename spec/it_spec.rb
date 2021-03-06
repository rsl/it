require 'spec_helper'
require 'it'

describe It do
  describe '.it' do
    it 'translates inside the controller as well' do
      I18n.backend.store_translations(:en, test1: 'I have a %{link:link to Rails} in the middle.')
      expect(
        It.it('test1', link: It.link('http://www.rubyonrails.org'))
      ).to eq('I have a <a href="http://www.rubyonrails.org">link to Rails</a> in the middle.')
    end

    it 'uses default key if no translation is present on specified key' do
      I18n.backend.store_translations(:en, fallback: 'this is a fallback')
      expect(It.it('a.missing.key', default: :fallback)).to eq('this is a fallback')
    end

    it 'uses default string if key is missing' do
      expect(It.it('a.missing.key', default: 'this is a fallback string')).to eq('this is a fallback string')
    end

    it 'uses scope if provided' do
      I18n.backend.store_translations(:en, deeply: {nested: {key: 'this is a nested translation'}})
      expect(It.it('key', scope: [:deeply, :nested])).to eq('this is a nested translation')
    end

    context 'With a pluralized translation' do
      before do
        I18n.backend.store_translations(
          :en,
          messages: {
            zero: 'You have zero messages.',
            one: 'You have %{link:one message}.',
            other: 'You have %{link:%{count} messages}.'
          }
        )
      end

      it 'works with count = 0' do
        expect(It.it('messages', count: 0, link: '/messages')).to eq('You have zero messages.')
      end

      it 'works with count = 1' do
        expect(It.it('messages', count: 1, link: '/messages')).to eq('You have <a href="/messages">one message</a>.')
      end

      it 'works with count > 1' do
        expect(It.it('messages', count: 2, link: '/messages')).to eq('You have <a href="/messages">2 messages</a>.')
      end
    end
  end

  describe '.link' do
    it 'returns an It::Link object' do
      expect(It.link('https://www.github.com')).to be_a(It::Link)
    end

    it 'accepts one param' do
      expect { It.link('http://www.rubyonrails.org/') }.not_to raise_error
    end

    it 'accepts two params' do
      expect { It.link('http://www.rubyonrails.org/', id: 'identity', class: 'classy') }.not_to raise_error
    end

    it 'raises ArgumentError, if called with three params' do
      expect { It.link('http://www.rubyonrails.org/', {}, :blubb) }.to raise_error(ArgumentError)
    end
  end

  describe '.tag' do
    it 'returns an It::Tag object' do
      expect(It.tag(:b)).to be_a(It::Tag)
    end

    it 'works with a param' do
      expect { It.tag(:b) }.not_to raise_error
    end

    it 'accepts two params' do
      expect { It.tag(:b, class: 'very_bold') }.not_to raise_error
    end

    it 'raises an ArgumentError if called with three params' do
      expect { It.tag(:b, {}, :blubb) }.to raise_error(ArgumentError)
    end
  end

  describe '.plain' do
    it 'returns an It::Plain object' do
      expect(It.plain).to be_a(It::Plain)
    end

    it 'works without params' do
      expect { It.plain }.not_to raise_error
    end

    it 'accepts one param' do
      expect { It.plain('%s[http://www.rubyonrails.org/]') }.not_to raise_error
    end

    it 'raises ArgumentError, if called with two params' do
      expect { It.plain('%s[http://www.rubyonrails.org/]', :blubb) }.to raise_error(ArgumentError)
    end
  end
end

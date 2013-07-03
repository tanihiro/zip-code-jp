# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

describe ZipCodeJp do

  describe 'If you want to search from the zip code.' do
    it 'zip code exists.' do
      address = ZipCodeJp.find '152-0004'
      expect(address.prefecture).to eq('東京都')
      expect(address.prefecture_kana).to eq('トウキョウト')
      expect(address.prefecture_code).to eq(13)
      expect(address.city).to eq('目黒区')
      expect(address.city_kana).to eq('メグロク')
      expect(address.town).to eq('鷹番')
      expect(address.town_kana).to eq('タカバン')
    end

    it 'zip code does not exists.' do
      address = ZipCodeJp.find '000-0000'
      expect(address).to eq(false)
    end
  end
end

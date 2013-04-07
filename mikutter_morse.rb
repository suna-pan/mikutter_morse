# -*- coding: utf-8 -*-

class Morse

    def initialize
        @table = {
            'い' => '・－', 'ろ' => '・－・－', 'は' => '－・・・', 
            'に' => '－・－・', 'ほ' => '－・・', 'へ' => '・', 
            'と' => '・・－・・', 'ち' => '・・－・', 'り' => '－－・', 
            'ぬ' => '・・・・', 'る' => '－・－－・', 'を' => '・－－－', 
            'わ' => '－・－','か' => '・－・・', 'よ' => '－－', 
            'た' => '－・', 'れ' => '－－－', 'そ' => '－－－・', 
            'つ' => '・－－・', 'ね' => '－－・－', 'な' => '・－・', 
            'ら' => '・・・', 'む' => '－', 'う' => '・・－', 
            'ヰ' => '・－・・－', 'の' => '・・－－', 'お' => '・－・・・', 
            'く' => '・・・－', 'や' => '・－－', 'ま' => '－・・－', 
            'け' => '－・－－', 'ふ' => '－－・・', 'こ' => '－－－－', 
            'え' => '－・－－－', 'て' => '・－・－－', 'あ' => '－－・－－', 
            'さ' => '－・－・－', 'き' => '－・－・・', 'ゆ' => '－・・－－', 
            'め' => '－・・・－', 'み' => '・・－・－', 'し' => '－－・－・', 
            'ヱ' => '・－－・・', 'ひ' => '－－・・－', 'も' => '－・・－・', 
            'せ' => '・－－－・', 'す' => '－－－・－', 'ん' => '・－・－・', 
            '゛' => '・・', '゜' => '・・－－・', 'ー' => '・－－・－', 
            '1' => '・－－－－', '2' => '・・－－－', '3' => '・・・－－', 
            '4' => '・・・・－', '5' => '・・・・・', '6' => '－・・・・', 
            '7' => '－－・・・', '8' => '－－－・・', '9' => '－－－－・', 
            '0' => '－－－－－'}
    end

    #引数(文字列) => モールス
    def encode(str)
        morse = String.new
        ary = str.split(//)
        ary.each do |w|
            begin
                morse << @table[w] + ' '
            rescue
                morse << w
            end
        end
        return morse.strip
    end

    #引数(モールス) => 文字列
    def decode(morse)
        str = String.new
        ary = morse.split(/\s+/)
        ary.each do |w|
            begin
                str << @table.key(w)
            rescue
                str << w
            end
        end
        return str
    end
end
        
Plugin.create(:mikutter_morse) do

    command(:toMorse,
            name: "モールスにする",
            condition: Plugin::Command[:Editable],
            visible: true,
            role: :postbox
    ) do |opt|
        toMorse(opt)
    end

    def toMorse(opt)
        buf =  Plugin.create(:gtk).widgetof(opt.widget).widget_post.buffer
        id,str = splitId(buf.text)
        buf.text =  id + @morse.encode(str)
    end

    def toString(text)
        id,str = splitId(text)
        str = id + @morse.decode(str)
        return str 
    end

    def isMorse(text)
        id,str = splitId(text)
        ary = str.split(//)
        ary.each do |c|
            return false unless /[\s・－]/ =~ c
        end
        return true
    end

    def splitId(text)
        if /(^@.*?\s)(.*)/ =~ text
            return $1,$2
        else
            return '',text
        end
    end

    on_boot do
        @morse = Morse.new
    end

    filter_show_filter do |msgs|
        msgs = msgs.select do |m|
            if isMorse(m[:message])
                m[:message]  = "#{m[:message]} (#{toString(m[:message])})"
            end
            true
        end
        [msgs]
    end
end

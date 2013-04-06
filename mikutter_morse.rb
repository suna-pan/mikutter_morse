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
    ) do
        toMorse
    end

    def toMorse
        buf =  Gtk::PostBox.list.first.widget_post.buffer
        if /(^@.*\s)(.*)/ =~ buf.text
            buf.text = $1 + @morse.encode($2)
        else
            buf.text =  @morse.encode(buf.text)
        end
    end

    def toString(text)
        return @morse.decode(text) 
    end

    def isMorse(text)
        ary = text.split(//)
        ary.each do |c|
            return false unless /[\s・－]/ =~ c
        end
        return true
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

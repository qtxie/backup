#-------------------------------------------------------------------------------
# Name:        youdao2kingsoft.py
# Purpose:     有道词典生词本(txt格式)转换成金山糍粑的生词本(txt格式) ;-)
#
# Author:      qtxie
#
# Created:     27-04-2012
#-------------------------------------------------------------------------------
#!/usr/bin/env python

# -*- coding: UTF-8 -*-
import sys
import os
import codecs
import io

def write_utf16(outfile, content):
    outfile.write(content.encode('utf-16le'))

def writeline(outfile, line):
    outfile.write(line.encode('utf-16le'))
    outfile.write("\x0D\x00\x0A\x00")    # trick: '\n'.encode('utf-16le') only ouput a '\x0A\x00'

def youdao_to_kingsoft(youdao_dict, kingsoft_dict):
    all_words = {}
    current_word = None
    youdao_file = io.open(youdao_dict, "r", encoding = "utf-16le")
    first = True
    for line in youdao_file:
        if first:
            first = False
            line = line[1:]
        if line[0].isdigit():
            words = line.split()
            current_word = words[1]
            if len(words) > 2:
                phonetic = words[2][1:-1]
            else:
                phonetic = ''

            all_words.setdefault(current_word, []).append(phonetic)
        else:
            all_words.setdefault(current_word, []).append(line[:-1])

    kingsoft_file = open(kingsoft_dict, 'wb')

    kingsoft_file.write(codecs.BOM_UTF16_LE)
    for word, detail in all_words.items():
        write_utf16(kingsoft_file, u'+')
        writeline(kingsoft_file, word)
        detail.reverse()
        phonetic = detail.pop()
        for line in detail:
            write_utf16(kingsoft_file, u'#')
            writeline(kingsoft_file, line)
        write_utf16(kingsoft_file, u'&')
        writeline(kingsoft_file, phonetic)
        writeline(kingsoft_file, u'@1335489278')
        writeline(kingsoft_file, u'$1')
    kingsoft_file.close()

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print 'Usage: %s youdao_dict_txt kingsoft_dict_txt' % (os.path.basename(sys.argv[0]))
        sys.exit(-1)

    youdao_dict = sys.argv[1]
    kingsoft_dict = sys.argv[2]

    youdao_to_kingsoft(youdao_dict, kingsoft_dict)

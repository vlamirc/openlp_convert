#!/usr/bin/ruby

require 'date'

def importa(file, old_new, livro_id, bookFile, verseFile)
   chapter = 0
   File.readlines(file).each do |line|
      if line[0] == '>'
         line_data = line.split(" [")
         book = line_data[0][1..-1]
         chapter = line_data[1][0..line_data[1].index(']')-1]
         puts "Livro : #{book} --- Capitulo #{chapter}"
         if chapter == '1'
            livro_id = livro_id + 1
            bookFile.write("#{livro_id},#{old_new},#{book},none\n")
         end
      else
         # point = line.index('. ')  ## versão ra
         point = line.index(' ')  ## versão ib
         verse = line[0..point-1]
         text = line[point+2..-1].rstrip  ## versão ra
         text = line[point+1..-1].rstrip  ## versão ib
         verseFile.write("#{livro_id},#{chapter},#{verse},\"#{text}\"\n")
      end
   end
   livro_id
end

livro_id = 0
sufixo = "ib"

puts "Import Bible"
puts "Data: #{Date.today} - Hora: #{Time.now}"
puts "-------------------------------------------------------------"
puts ""

bookFile = File.open("book_new_#{sufixo}.csv","w")
verseFile = File.open("verse_new_#{sufixo}.csv","w")
livro_id = importa(File.open("Velho_#{sufixo}.txt"), 1, livro_id, bookFile, verseFile)
livro_id = importa(File.open("Novo_#{sufixo}.txt"), 2, livro_id, bookFile, verseFile)
bookFile.close
verseFile.close

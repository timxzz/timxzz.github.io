 module Jekyll
  module HideCustomBibtex
    def hideCustomBibtex(input)
	  keywords = @context.registers[:site].config['filtered_bibtex_keywords']

	  keywords.each do |keyword|
      if keyword == 'author'
        # Remove specific symbols only from author values, 
        # e.g., hide equal contribution symbols in bibtex author field

        # Define the symbols to be removed
        symbols_to_remove = /[¶&*†^]/
        # Match the author field and its content
        input = input.gsub(/(author\s*=\s*{)([^}]*)}/) do |match|
          # Replace the specified symbols in the author field content
          $1 + $2.gsub(symbols_to_remove, '') + '}'
        end
      else
        # input = input.gsub(/^.*#{keyword}.*$\n/, '')
        input = input.gsub(/^\s*#{keyword}\s*=\s*{.*$\n/, '')
      end
	  end

      return input
    end
  end
end

Liquid::Template.register_filter(Jekyll::HideCustomBibtex)

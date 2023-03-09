 module Jekyll
  module HideCustomBibtex
    def hideCustomBibtex(input)
	  keywords = @context.registers[:site].config['filtered_bibtex_keywords']

	  keywords.each do |keyword|
		# input = input.gsub(/^.*#{keyword}.*$\n/, '')
    input = input.gsub(/^\s*#{keyword}\s*=\s*{.*$\n/, '')
	  end

      return input
    end
  end
end

Liquid::Template.register_filter(Jekyll::HideCustomBibtex)

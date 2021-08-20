

def parse_servings(servings_text):
    unit = ''
    words = servings_text.split()
    for index, word in enumerate(words, start=0):
        try:
            potential = int(word)
            if servings == 0:
                servings = potential
        except ValueError:
            if servings != 0:
                if 'to' != word:
                    for i in range(index, len(words)):
                        unit += words[i] + ' '
                    return servings, unit[:-1]
    return servings, 'servings'

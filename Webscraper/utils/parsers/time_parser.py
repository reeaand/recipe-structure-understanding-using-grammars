
def parse_time(time_text):
    words = time_text.split()
    number = 0
    minutes = 0
    hours = 0
    for word in words:
        try:
            number = int(word, base=10)
        except ValueError:
            if word[0] == 'm':
                minutes = number
                number = 0
            elif word[0] == 'h':
                hours = number
                number = 0
            elif '/' in word:
                parts = word.split(sep='/')
                if len(parts) == 2:
                    try:
                        left = int(parts[0])
                        right = int(parts[1])

                        number = number + 1.0 * left / right
                    except ValueError:
                        pass
    return int(hours * 60 + minutes)

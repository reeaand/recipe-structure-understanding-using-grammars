import unicodedata


def convert_unicode_to_string(s):
    rez = ''
    for c in s:
        try:
            name = unicodedata.name(c)
        except ValueError:
            continue
        if name.startswith('VULGAR FRACTION'):
            normalized = unicodedata.normalize('NFKC', c)
            numerator, _slash, denominator = normalized.partition('⁄')
            rez += numerator + '/' + denominator
        else:
            rez += c
    return rez

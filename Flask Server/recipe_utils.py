import subprocess


def run_out_file():
    """
    Runs the a.out file to get the recipe tree
    @return: -
    """
    f = open("input.txt", "r")
    subprocess.Popen(["./a.out"], stdin=f, shell=False, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)


def write_input(sentence):
    """
    Writes the input sentence in an input file for the a.out executable
    @param sentence: the recipe's text
    @return: -
    """
    f = open("input.txt", "w")
    f.write(sentence + "\n")
    f.close()


def get_result():
    """
    Read the recipe tree from the recipe.json file
    @return:
    """
    f = open("recipe.json", "r")
    result = f.read()
    f.close()
    return result


def process_sentence(sentence):
    """
    Processes the input and gets the recipe tree
    @param sentence: input text
    @return: the recipe tree
    """
    sentence = sentence.replace("\n", "")
    write_input(sentence)
    run_out_file()
    return get_result()

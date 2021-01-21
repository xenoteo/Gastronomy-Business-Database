import os


class Formatter:
    """" Class responsible for changing the format of SQL script. """

    def __init__(self, filename):
        self.filename = filename        # the path to the file to edit
        self.temp_filename = filename   # the path to the temp buffer file
        self.set_temp_file()
        self.KEYWORDS = ['int', 'nvarchar', 'varchar', 'null', 'bit', 'datetime', 'float', ' on ', 'set',
                         ' table ', 'select', 'from']   # a list of keywords to set uppercase

    def set_temp_file(self):
        """
        A function that sets the path to the temp buffer file
        adding to the filename of the main file prefix 'tmp_'.
        """

        index = self.filename.rfind('/') + 1
        self.temp_filename = self.filename[:index] + "tmp_" + self.filename[index:]

    def uppercase(self):
        """ A function looking for keywords and setting them uppercase. """

        file = open(self.filename, 'r')
        new_file = open(self.temp_filename, 'w')
        for line in file:
            for keyword in self.KEYWORDS:
                if keyword in line:
                    line = line.replace(keyword, keyword.upper())
            new_file.write(line)
        file.close()
        new_file.close()
        self.overwrite_file()

    def capitalize(self):
        """ A function looking for SQL variables and capitalizing them.  """

        file = open(self.filename, 'r')
        new_file = open(self.temp_filename, 'w')
        for line in file:
            new_line = ""
            for i in range(len(line)):
                char = line[i]
                if char == '@':
                    line = line[:i + 1] + line[i + 1].upper() + line[i + 2:]
                new_line += char
            new_file.write(new_line)
        file.close()
        new_file.close()
        self.overwrite_file()

    def remove_GOs(self):
        """ A function removing all the GOs from the script. """

        file = open(self.filename, 'r')
        new_file = open(self.temp_filename, 'w')
        for line in file:
            if "GO" not in line and "go" not in line:
                new_file.write(line)
        file.close()
        new_file.close()
        self.overwrite_file()

    def overwrite_file(self):
        """ A function that writes the content of the buffer file to the main file and removes the buffer file. """

        new_file = open(self.temp_filename, 'r')
        file = open(self.filename, 'w')
        file.writelines(new_file.readlines())
        new_file.close()
        file.close()
        os.remove(self.temp_filename)

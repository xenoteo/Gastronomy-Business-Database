import os


class Formatter:
    def __init__(self, filename, new_filename):
        self.filename = filename
        self.new_filename = new_filename
        self.KEYWORDS = ['int', 'nvarchar', 'varchar', 'null', 'bit', 'datetime', 'float', ' on ', 'set', ' table ', 'select', 'from']

    def uppercase(self):
        file = open(self.filename, 'r')
        new_file = open(self.new_filename, 'w')
        for line in file:
            for keyword in self.KEYWORDS:
                if keyword in line:
                    line = line.replace(keyword, keyword.upper())
            new_file.write(line)
        file.close()
        new_file.close()
        self.overwrite_file()

    def capitalize(self):
        file = open(self.filename, 'r')
        new_file = open(self.new_filename, 'w')
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

    def clear_go(self):
        file = open(self.filename, 'r')
        new_file = open(self.new_filename, 'w')
        for line in file:
            if "GO" not in line:
                new_file.write(line)
        file.close()
        new_file.close()
        self.overwrite_file()

    def add_go(self):
        file = open(self.filename, 'r')
        new_file = open(self.new_filename, 'w')
        for line in file:
            new_file.write(line)
            if "IF EXISTS" in line:
                new_file.write("GO\n")
        file.close()
        new_file.close()
        self.overwrite_file()

    def overwrite_file(self):
        new_file = open(self.new_filename, 'r')
        file = open(self.filename, 'w')
        file.writelines(new_file.readlines())
        new_file.close()
        file.close()
        os.remove(self.new_filename)

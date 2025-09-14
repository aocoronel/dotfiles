from ranger.api.commands import Command
import subprocess

class move_left_and_zadd(Command):
    def execute(self):
        directory = self.fm.thisdir.path
        subprocess.run(['zoxide', 'add', directory])
        self.fm.execute_console('cd ..')

class move_right_and_zadd(Command):
    def execute(self):
        directory = self.fm.thisdir.path
        subprocess.run(['zoxide', 'add', directory])
        self.fm.move(right=True)

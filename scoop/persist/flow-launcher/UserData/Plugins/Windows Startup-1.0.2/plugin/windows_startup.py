import os
from subprocess import Popen
from pathlib import Path
from typing import Callable

from flox import Flox

import startup

ICONS_DIR = Path.joinpath(Path(__file__).absolute().parent.parent, "icons")
ENABLED_ICON = str(Path(ICONS_DIR).joinpath("check-circle.png"))
DISABLED_ICON = str(Path(ICONS_DIR).joinpath("checkbox-blank-circle.png"))
class WindowsStartup(Flox):

    def query(self, query):
        programs = startup.get_startup_programs()
        for program in programs:
            if query.lower() in program.name.lower():
                subtitle = f"❌{program.status}"
                if program.value():
                    subtitle = f"✔️{program.status} - Press ENTER to toggle program startup behavior"
                self.add_item(
                    title=program.name.replace(".lnk", ""),
                    subtitle=subtitle,
                    icon=program.path,
                    method=self.toggle,
                    parameters=[str(program._base_key), str(program._reg_path), str(program._key_index)],
                    context=[str(program._base_key), str(program._reg_path), str(program._key_index)]
                )

    def context_menu(self, data):
        prog = startup.StartupProgram(int(data[0]), data[1], int(data[2]))

        self.add_item(
            title="Open Program",
            subtitle=prog.path,
            icon=prog.path,
            method=self.open_program,
            parameters=[prog.path]
        )
        self.add_item(
            title="Reveal in Explorer",
            subtitle="Reveals and selects program in file explorer.",
            icon=str(Path(os.getenv('WINDIR'), 'explorer.exe')),
            method=self.reveal_in_finder,
            parameters=[prog.path]
        )
        self.add_item(
                title="Enable Program",
                subtitle="Allow program to start with Windows.",
                icon=ENABLED_ICON,
                method=self.enable,
                parameters=[str(prog._base_key), str(prog._reg_path), str(prog._key_index)]
        )
        self.add_item(
            title="Disable Program",
            subtitle="Prevent program from starting with Windows.",
            icon=DISABLED_ICON,
            method=self.disable,
            parameters=[str(prog._base_key), str(prog._reg_path), str(prog._key_index)]
        )

    def change_program(self, program: startup.StartupProgram, method: Callable):
        _begin_state = program.value()
        method()
        title = self.manifest['Name']
        icon = str(Path(self.plugindir).joinpath(self.icon))
        if program.value() != _begin_state:
            title = f"{title}: {program.status}!"
            msg = f"{program.name.title()} start-up is {program.status}"
        else:
            title = f"{title}: ERROR!"
            msg = f"Unable to change {program.name} to {program.status}!"
        self.show_msg(title, msg, ico_path=icon)

    def enable(self, base_key, path, key_index):
        prog = startup.StartupProgram(int(base_key), path, int(key_index))
        self.change_program(prog, prog.enable)

    def disable(self, base_key, path, key_index):
        prog = startup.StartupProgram(int(base_key), path, int(key_index))
        self.change_program(prog, prog.disable)

    def toggle(self, base_key, path, key_index):
        prog = startup.StartupProgram(int(base_key), path, int(key_index))
        self.change_program(prog, prog.toggle)

    def open_program(self, path):
        os.startfile(path)

    def reveal_in_finder(self, path):
        Popen(f"explorer /select,{path}")


if __name__ == "__main__":
    WindowsStartup()

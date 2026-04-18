from ansible.plugins.become import BecomeBase

class BecomeModule(BecomeBase):
    name = 'dzdo'

    def (build_become_command(self,cmd, shell=None):
            return f'dzdo {cmd}'

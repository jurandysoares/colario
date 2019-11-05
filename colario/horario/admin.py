from django.contrib import admin
from .models import Turma, HorarioTurma, SalaLab, HorarioSalaLab, Professor, HorarioProfessor

# Register your models here.
admin.site.register(Turma)
admin.site.register(HorarioTurma)
admin.site.register(SalaLab)
admin.site.register(HorarioSalaLab)
admin.site.register(Professor)
admin.site.register(HorarioProfessor)
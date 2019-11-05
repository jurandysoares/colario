from django.db import models

# Create your models here.

class Turma(models.Model):
    slug = models.CharField(max_length=15)
    nome = models.CharField(max_length=30)

    def __str__(self):
        return self.nome

class HorarioTurma(models.Model):
    turma = models.ForeignKey(Turma)
    data_pub = models.DateField('Data de publicação')
    texto = models.TextField()
    pdf = models.CharField(max_length=50)

class SalaLab(models.Model):
    slug = models.CharField(max_length=15)
    nome = models.CharField(max_length=30)

    def __str__(self):
        return self.nome

class HorarioSalaLab(models.Model):
    salalab = models.ForeignKey(SalaLab)
    data_pub = models.DateField('Data de publicação')
    texto = models.TextField()
    pdf = models.CharField(max_length=50)

class Professor(models.Model):
    slug = models.CharField(max_length=15)
    nome = models.CharField(max_length=30)

    def __str__(self):
        return self.nome

class HorarioProfessor(models.Model):
    professor = models.ForeignKey(Professor)
    data_pub = models.DateField('Data de publicação')
    texto = models.TextField()
    pdf = models.CharField(max_length=50)

class Horario(models.Model):
    turma = models.ForeignKey(Turma)
    salalab = models.ForeignKey(SalaLab)
    professor = models.ForeignKey(Professor)

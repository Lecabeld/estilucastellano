import matplotlib.pyplot as plt

materias = ["Lectura", "Matemática", "Ciencia", "Arte"]
progreso = [80, 65, 90, 70]

plt.bar(materias, progreso)
plt.xlabel("Materias")
plt.ylabel("Progreso (%)")
plt.title("Progreso Educativo")
plt.show()

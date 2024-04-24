The simplest voronoi map implementation for test purposes. Written in Godot game engine. Bear in mind that it's a quite slow solution, and developed mainly for visual purposed and mostly or screenshots for [this article](https://habr.com/ru/articles/794572/).

# Examples

Euclidean metric ($p=2$). Detalization = 1px

![image](https://github.com/AskePit/VoronoiTestGodot/assets/23142629/626a75e1-4426-47a4-9114-d42fc594ad6c)

---

Manhattan metric ($p=1$). Detalization = 5px

![image](https://github.com/AskePit/VoronoiTestGodot/assets/23142629/4947b921-cda8-49fb-b785-4aa5a97c83d1)

---

Chebyshev metric ($p=\infty$). Detalization = 3px

![image](https://github.com/AskePit/VoronoiTestGodot/assets/23142629/08f2b2b9-f5bd-49ad-aded-4cba8517b636)

---

Metric $p=1.5$. Detalization = 1px

![image](https://github.com/AskePit/VoronoiTestGodot/assets/23142629/961239d0-01a5-4130-b01c-9acdb58f05fa)

# Usage

- Run Godot project with Godot version specified in `version.txt` file.
- Open `voronoi.tscn` scene in FileSystem tab
- Press F6 or F5 to execute the scene
- You can change the following parameters in the Inspector tab in the runtime:



    ![image](https://github.com/AskePit/VoronoiTestGodot/assets/23142629/84ea8e8d-cd09-429c-948b-6cac7cb530b1)

  
  where
  
  - **Sites Count** is count of points in a map
  - **Metric** is a distance metric used in a Voronoi map construction calculations
  - **Points Seed** is a seed that defines points position on a map
  - **Color Seed** is a seed that defines regions' colors
  - **Unsaturation** is a color unsaturation coefficient
  - **Detalization** is a level of map's pixelization. Higher is more pixelated but faster to calculate
- You can terminate program by Alt+F4 or by clicking Stop button in the Godot editor

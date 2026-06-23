# SBA*
An Improved A* Algorithm for 2D Path Planning of Unmanned Vehicles

This implementation is based on the A* path planning framework from: https://github.com/joedavidbuilds/FOMR-1

This project proposes a novel path planning method called Segment-Based A* (SBA*) aimed at objectives such as generating near-optimal paths, avoiding collisions, and reducing energy consumption. The contributions of the method can be summarized as follows:

• By segmenting the path and creating a local graph for each segment, the total rotation angle, sharp turns, and intensive maneuvers are reduced.

• Near-optimal paths are generated, allowing UVs to move more effectively and efficiently.

• Smoother paths enable the maintenance of UVs’ speed and acceleration during motion, minimizing energy consumption.

• Safe paths are planned to enable UVs to overcome obstacles encountered in complex 3D environments.

Paper: https://doi.org/10.1016/j.matcom.2024.12.015

<img width="632" height="512" alt="image" src="https://github.com/user-attachments/assets/a7b5a072-0987-432a-8636-ce0a7ab57bbb" />

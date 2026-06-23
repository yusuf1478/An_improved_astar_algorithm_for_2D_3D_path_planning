# SBA*
An Improved A* Algorithm

This implementation is based on the A* path planning framework from: https://github.com/joedavidbuilds/FOMR-1

This project propose a novel path planning method called Segment-Based A* (SBA*) aimed at objectives such as generating near-optimal paths, avoiding collisions, and reducing energy consumption. SBA* algorithm has been developed to overcome the complexities encountered by UVs in 3D environments. Using the proposed method, a 3D undirected graph is first created by randomly placing nodes in complex 3D continuous space environments. This graph provides a suitable structure for UVs to navigate around surrounding obstacles to reach their target destinations. Subsequently, new paths are planned on the generated graph, navigating around obstacles between the source and target. This stage focuses on minimizing the total rotation angle, sharp turns, and intensive maneuvers. Thus, more efficient and smoother paths are achieved, reducing energy consumption for UVs.

SBA* algorithm is based on segmenting the path and creating a local graph for each segment. This allows for a more precise search and ensures that the paths are smoother. Additionally, SBA* algorithm helps minimize energy consumption by maintaining the speed and acceleration of UVs during motion. This approach enhances the performance of UVs while also maximizing energy efficiency. The proposed method demonstrates superior performance compared to existing path planning algorithms, enabling UVs to move more effectively and efficiently in complex 3D environments. Therefore, SBA* algorithm provides a significant contribution for both academic research and practical applications. The contributions of the method can be summarized as follows:

• By segmenting the path and creating a local graph for each segment, the total rotation angle, sharp turns, and intensive maneuvers are reduced.

• Near-optimal paths are generated, allowing UVs to move more effectively and efficiently.

• Smoother paths enable the maintenance of UVs’ speed and acceleration during motion, minimizing energy consumption.

• Safe paths are planned to enable UVs to overcome obstacles encountered in complex 3D environments.

Paper: https://doi.org/10.1016/j.matcom.2024.12.015

<img width="632" height="512" alt="image" src="https://github.com/user-attachments/assets/a7b5a072-0987-432a-8636-ce0a7ab57bbb" />

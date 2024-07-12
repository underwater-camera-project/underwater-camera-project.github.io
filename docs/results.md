---
---

# Results 

Given the available components and a budget of 500 Euro, it is possible to build a camera for permanent underwater installation. No special tools are required for implementation. 

The Raspberry Pi Zero 2 W with its encoders on the GPU has proven to be the right single board computer for this project. It enables the simultaneous generation of an H.264 and an MPJPEG video stream. The four CPU cores remain available for the execution of other activities, such as the web server. Furthermore, the numerous external interfaces of the Raspberry Pi enable the use of a wide variety of actuators and sensors, making it a very powerful, flexible and inexpensive platform.

The integration of the infrared LEDs very close to the camera module proved to be suboptimal, as a small amount of infrared light is reflected onto the camera sensor via the viewing window. This has a negative impact on the image quality. 

The measurement data was analysed using several Jupyter notebooks. This meant that the manual creation of diagrams could be avoided. Instead, they were defined as code and can be generated and customised at any time. This was inspired by IaC (Infrastructure as Code). DaC (Diagram as Code) would be appropriate for the diagrams. The notebooks with all necessary data are available in the following repository.

<a href="https://github.com/tederer/octowatch-evaluation" target="_blank">Jupyter Notebooks used for evaluating the data</a>
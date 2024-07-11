---
---

# Software

The following figure shows the software architecture of the underwater camera. It consists of four services that are executed on the Raspberry Pi Zero 2 W. The video service is responsible for retrieving a sequence of images in YUV420 format from the camera module. It then generates an H.264 (1920 x 1080 pixel) and an MPJPEG (800 x 600 pixel) video stream. The H.264 video stream is intended for on-site recording. The MPJPEG stream is used to display the video on the camera's website. The content of that web page is provided by the web server. The camera's attributes are collected by the Prometheus service and made available to other services via its public interface. Dimming the infrared LEDs is the task of the InfraredLight service.

<figure class="figure">
    <img src="/images/architecture.png" class="figure-img img-fluid">
    <figcaption class="figure-caption text-center">architecture of the underwater camera</figcaption>
</figure>

## JPEG Encoding

Converting the raw images of the camera module into JPEG format is a necessary procedure for generating the MPJPEG video stream. The conversion of the images can be carried out using the libjpeg and libjpeg-turbo libraries on the CPU. Both libraries have a compatible API. In addition to the H.264 encoder, the Raspberry Pi Zero 2 W also has a JPEG encoder on the GPU. To measure the speed of the options presented, 1000 photos (800 x 600 pixel) were collected and passed to each encoder for conversion. This process was repeated 100 times and the duration of each process was measured. The following diagram presents the results of this measurement. 

<figure class="figure">
    <img src="/images/jpegEncodingPerformance_500pixel_wide.png" class="figure-img img-fluid">
    <figcaption class="figure-caption text-center">JPEG encoding performance</figcaption>
</figure>

The high speed of the JPEG encoder on the GPU led to the decision to convert the images on the GPU. This relieves the load on the four CPU cores of the Raspberry Pi so that sufficient time is available to process events between the individual images. In this way, a frame rate of 30 frames per second can be achieved without any problems.

## Dimming the infrared LEDs

The first implementation of the InfraredLight service was based on the Python library gpiozero. With this library, a pulse width modulated signal (PWM) could easily be output on a digital output of the Raspberry Pi. However, this solution led to interference in both video streams. Horizontal bars ran through the picture, similar to old TV movies in which a TV was filmed. The cause of the interference was the PWM signal's clock frequency being too low. The solution to the problem was to generate the signal close to the hardware. The Raspberry Pi has counters that can be used with the libpigpio library to generate the PWM signal and thus achieve a frequency of up to 30 kHz. The following image shows one of the video streams with the described interference.

<figure class="figure">
    <img src="/images/irlightInfluenceAtLowFrequency.png" class="figure-img img-fluid">
    <figcaption class="figure-caption text-center">interferences when using low PWM signal frequency</figcaption>
</figure>

## Proxy (nginx)

In addition to the camera's services, a proxy is required because web browsers prevent a video from being displayed if it does not come from the same source as the web page in which the video is embedded. The different ports used by the web server and the MPJPEG video stream are sufficient for the browsers to consider the two sources as independent of each other. The problem is solved by using a proxy (nginx) as the single point of contact for the browser. The nginx configuration used is as follows:

```
events {
}

http {
    server {
        listen 80;
     
        location / video {
           proxy_pass http ://192.168.1.1:8887;
        }
     
        location / {
            proxy_set_header X - Forwarded - For
            $proxy_add_x_forwarded_for ;
            proxy_set_header Host $host ;
     
            proxy_pass http ://192.168.1.1:8081;
     
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade ;
            proxy_set_header Connection " upgrade ";
        }
    }
}
```

## Code Repositories

The source code for each service is freely available in a separate repository. Further descriptions can be found in the respective repositories.

<ul class="list-group">
    <li class="list-group-item"><a href="https://github.com/tederer/octowatch-videoservice" target="_blank">Video Service</a></li>
    <li class="list-group-item"><a href="https://github.com/tederer/octowatch-webservice" target="_blank">Web Server</a></li>
    <li class="list-group-item"><a href="https://github.com/tederer/octowatch-monitoring" target="_blank">Monitoring Service</a></li>
    <li class="list-group-item"><a href="https://github.com/tederer/octowatch-irlightcontrol" target="_blank">InfraredLight Service</a></li>
</ul>


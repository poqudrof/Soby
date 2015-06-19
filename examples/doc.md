

# Tags :

In the title :

### code

Will interpret the code of the description. 
The code is interpreted during the draw, more precisely, the draw order is : 

1. custom_pre_draw 
2. draw the SVG
3. draw the videos
4. draw slide code 
5. display_slide_number 
6. custom_post_draw

### animation 

Description : 

* slideID
* number 


Here is an example use. 
* Create a Frame with the Title "marker" in Sozi.

(first animation)
* marker
* 0

(second animation)
* marker
* 1 


### Video

Description : 

* slideID
* videoFilePath


Here is an example use. 
* Create a Frame with the Title "Video 1" in Sozi.

Create a rect with a title : "video" and this description
* Video 1
* data/dragon.MP4



# Flickr30k Entities Dataset

If you use our dataset please cite our [paper](https://arxiv.org/pdf/1505.04870.pdf).

    @article{flickrentitiesijcv,
        title={Flickr30k Entities: Collecting Region-to-Phrase Correspondences for Richer Image-to-Sentence Models},
        author={Bryan A. Plummer and Liwei Wang and Christopher M. Cervantes and Juan C. Caicedo and Julia Hockenmaier and Svetlana Lazebnik},
        journal={IJCV},
        volume={123},
        number={1},
        pages={74-93},
        year={2017}
    }

In addition to citing our dataset, please also reference the original Flickr30K dataset:

    @article{flickr30k,
        title={From image descriptions to visual denotations: New similarity metrics for semantic inference over event descriptions},
        author={Peter Young and Alice Lai and Micah Hodosh and Julia Hockenmaier},
        journal={TACL},
        volume={2},
        pages={67--78},
        year={2014}
    }

Note that the Flickr30k Dataset includes images obtained from [Flickr](https://www.flickr.com/). Use of the images must abide by the [Flickr Terms of Use](http://www.flickr.com/help/terms/). We do not own the copyright of the images. They are solely provided for researchers and educators who wish to use the dataset for non-commercial research and/or educational purposes.


### Version 1.0 

This dataset contains 244k coreference chains and 276k manually annotated bounding boxes for each of the 31,783 images and 158,915 English captions (five per image) in the original dataset. 

To obtain the images for this dataset, please visit the [Flickr30K webpage](http://hockenmaier.cs.illinois.edu/DenotationGraph/) and fill out the form linked to at tbe bottom of the page.

#### Coreference Chains:

Each image in the dataset has a txt file in the "Sentences" folder.  Each line of this file contains a caption with annotated phrases blocked off with brackets.  Each annotation has the following form:

    [/EN#<chain id>/<type 1>/<type 2>.../<type n> <word 1> <word 2> ... <word n>]

Phrases that belong to the same coreference chain share the same chain id.  Each phrase has one or more types associated with it, which correspond to the rough categories described in [1].  Phrases of the type "notvisual" have the null chain id of "0" and should be considered a set of singleton coreference chains since these phrases were not annotated.


#### Bounding Boxes or Scene/No Box:

Each image in the dataset has an xml file in the "Annotations" folder which follows a similar format to the PASCAL VOC datasets.  These files have object tags which either contain a bounding box defined by xmin,ymin,xmax,ymax tags or scene/no box binary flags contained in scene and nobndbox tags.

Each object tag also contains one or more name tags which contain the chain ids the object refers to.

#### Unrelated Captions:

We have a list of the captions in the dataset that do not relate to the images themselves in the UNRELATED_CAPTIONS file.  This list is likely incomplete.

#### Dataset Splits:

Flickr30K has been evaluated under multiple splits so have provided the image splits used in our experiments in the train.txt, test.txt, and val.txt files.

### Matlab Interface

We have included Matlab code to parse our data files.  

To extract Coreference information use the following function call:

    ```Shell
    >> corefData = getSentenceData('<path_to_annotation_directory>/Sentences/<image id>.txt');
    ```

To extract the xml data use the following:

    ```Shell
    >> annotationData = getAnnotations('<path_to_annotation_directory>/Annotations/<image id>.xml');
    ```
Please see each function for details about the structures returned from each function.

### Python Interface

The python interface to parse out data files follow the same format as the Matlab interface, except underscores were used rather than camel case.  Please see `flickr30k_entities_utils.py` for further information about the provided functions.

### Acknowledgements:

This material is based upon work supported by the National Science Foundation under Grants No. 1053856, 1205627, 1405883, IIS-1228082, and CIF-1302438 as well as support from  Xerox UAC and the Sloan Foundation. Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation or any sponsor.


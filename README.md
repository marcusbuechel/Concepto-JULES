![alt text](https://github.com/marcusbuechel/Concepto-JULES/blob/main/Readme_Files/Logo.JPG?raw=true)

# Concepto-JULES

Concepto-JULES is a set of bash scripts to enable JULES, a land surface model (https://jules.jchmr.org/), to run river catchments as a single point.

This code was initially written as part of the Advanced Scripting Course run by the University of Manchester.

Author: Marcus Buechel
Email: marcus.buechel@ouce.ox.ac.uk

## CAUTION:

This is still work in progress and has not been finished to run on all user accounts.
You need a JASMIN (http://jasmin.ac.uk/) user account to run Concepto-JULES.

## Background and Rational

As the study of hydrology continues we have an ever-growing plethora of numerical models. We have top-down, conceptual models that use our current perceptions of how a river catchment works as a single, lumped hydrological response unit. Simple to run, but often lumping many processes together and thus potentially leading to us losing the fidelity behind the hydrological processes driving catchment response to climatic and land forcing. For example, lumping vegetation and soil as a single water store. On the other hand we have physics-based, bottom-up, distributed models that are often more computationally demanding but use are understanding of physical processes to be more fidelious to the processes occurring and explicit to the physical stores. For more information have a look at: https://uofs-comphyd.github.io/blog/journey-model-continuum

![alt text](https://github.com/marcusbuechel/Concepto-JULES/blob/main/Readme_Files/Process_Breakdown.jpg?raw=true)
*JULES cartoon from https://jules.jchmr.org/*

With Concepto-JULES we aim to cross the divide to run small river catchments in JULES as a single point. This will help us to understand the dominant hydrological physics-based processes occurring in the catchment and to potentially improve our parameterizations and parameters within JULES.

For our test catchment we explore the River Tamar (Station at Gunnislake: https://nrfa.ceh.ac.uk/data/station/liveData/47001) in the southwest of the UK.

![alt text](https://github.com/marcusbuechel/Concepto-JULES/blob/main/Readme_Files/Catchment.jpg?raw=true)
*Base land cover map from https://www.ceh.ac.uk/services/land-cover-map-2000*

## Presentation

For a presentation explaining Concepto-JULES and the current progress please visit: https://ox.cloud.panopto.eu/Panopto/Pages/Viewer.aspx?id=e77be54d-ce8c-44db-ac23-accd011f8a45

## Contributing

Any help is much appreciated! If you would like to help develop the code please do get in touch with Marcus Buechel at marcus.buechel@ouce.ox.ac.uk

## Project Status

In development and not ready for final release.

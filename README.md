# NabtA Full App 

NabtA is a decision-support tool that helps farmers explore crop rotations more suitable for their soil based on verified data from NASA, FAO, USDA, and other globally certified organizations. The current version of the app takes farmer location alongside his land area and the pH value in the soil, these data is used then to get the soil & crop profile data (e.g. minimum and maximum optimal and absolute temperature values, minimum and maximum optimal and absolute rainfall need when crops are not irrigated, soil salinity values, etc.)

### This software was built on three parts:

#### 1. Data pipelines

The Data pipelines are the most crucial part in this project, there was of course much more than this files in the data gathering and preprocessing steps so this is just a final version of the code, this data pipelines are responsible for taking the data, using them to get soil data then comparing them with crops to get the most suitable ones, which in the end is called the rule-based model for the whole process combining all pipelines  

#### 2. Mobile Application

This whole project is built for one thing, to make it easier and much more reliable for the farmer when choosing crop-rotation strategy, so making it in the best and most accessible way was necessary.

#### 3. Back-end

This is the Connecting part between a pretty UI and complex rule-based model, The back-end is only one POST endpoint which takes the data needed and outputs the crop-rotation strategies recommended from the model

## Screenshots

| Inputs Screen | Output Screen |
| :---: | :---: |
| <img width="739" height="1600" alt="WhatsApp Image 2026-11-16 at 11 57 13 PM (1)" src="https://github.com/user-attachments/assets/d3fb15f9-b94b-4cae-89b8-526424725253" /> | <img width="739" height="1600" alt="WhatsApp Image 2026-11-16 at 11 57 15 PM (1)" src="https://github.com/user-attachments/assets/bb6eb737-4323-46f5-ab6a-61f0beffdb28" /> |

## [Canva Presentation](https://canva.link/7j5i5w45681lz01)

[<img width="1920" height="1080" alt="NabtA-Presentation-6-Slides pptx" src="https://github.com/user-attachments/assets/6c25651a-6cd0-458a-aabb-dc7787e5f07d" />](https://canva.link/7j5i5w45681lz01)

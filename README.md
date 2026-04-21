# Machine Learning Neurocomputational Mechanisms of Human Multisensory Learning
Project status: Ongoing 
## Abstract

This project explores the application of machine learning to predicting neural signals related to human reinforcement learning, focusing on whether shared modeling of separate but connected signals improves prediction performance. Using a BIDS-formatted fMRI dataset from 58 participants performing a multisensory reinforcement learning task across six runs, preprocessed with fMRIPrep and reduced to ROI-level features, this project investigates events in which the learning signals value (V) and surprise are defined. For each event, BOLD activity is extracted following an HRF delay and used to predict V and surprise either independently or jointly. Performance is evaluated using R-squared, mean squared error, and Pearson correlation, along with statistical comparisons between modeling approaches.

The original hypothesis, that shared neural representations of V and surprise had a significant effect on prediction performance, and that multi-task (MT) methods might generalize better than single-task (ST) methods because the signals are supported by a shared neurocomputational mechanism, could not be definitively proven. Models across linear and more advanced approaches struggled to learn from averaged window activations, and no model achieved an MSE below 0.985. MT models underperformed ST models, supporting the claim of Bedi et al. (2026) that the two signals arise from connected but distinct neural structures, and highlighting the difficulty of finding a BOLD encoding scheme.

## Introduction

Neuroimaging is the use of digital technologies to study the physiology of central nervous systems. It's a field with broad applications and many methods, one of which is functional magnetic resonance imaging (fMRI). fMRI detects and images brain activity by measuring the flow of blood through different parts of the brain. The underlying principles of fMRI imaging are that:

1) as parts of the brain activate, the oxygenated blood within them becomes deoxygenated, and is replaced by a flow of new oxygenated blood; and
2) the way magnetic frequencies passing through blood behave changes depending on the oxygen level of the blood.

These two facts form the basis of blood-oxygen-level contrast (BOLD), and enable fMRI machines to effectively visualize the activity of the brain in four dimensions (xyz coordinates, and time).

fMRI has broad applications in modern healthcare and research contexts. This project was inspired by the paper pre-print [1], in which key signals related to human multi-sensory learning: choice-phase value (V) and surprise, among others, were identified. V is a representation of the value of a choice made in a multisensory learning task; and surprise, known as Shannon surprise, is a representation of how unexpected a stimulus is, which is separate from the reward of a person’s choice (in the protocol of the original paper, reward was the feedback on a choice a person received, not an actual reward).

It was shown in [1] that fMRI may encode V and surprise through the use of fMRI data from a multisensory learning experiment to identify areas of the brain related to these signals. In [1], 58 participants completed a multisensory reinforcement learning task in which correct responses depended on combinations of visual and auditory or tactile cues rather than on any single sensory input alone. As participants completed the learning task, fMRI data was collected on them and associated with choice and feedback events. The authors showed that the previously identified signals are supported by separate but partly complementary neural systems. In particular, their results suggest that reinforcement-related and structure-related learning signals can be separated computationally, while still interacting within broader multisensory learning networks.

The fact that these signals can be represented through fMRI data begs the question of whether or not the values of these signals could be decoded from raw fMRI data. The present project builds on [1]'s work and tries to answer the aforementioned question from a machine learning (ML) perspective. Rather than using model-based fMRI analysis to identify where these signals are represented, this project asks whether preprocessed ROI-level BOLD activity can be used to predict the learning variables V and surprise themselves through regression. Furthermore, if the two signals rely on partially shared neural information, then joint modeling may improve performance relative to training separate models for each target. The central research question is therefore whether V and surprise can be decoded from ROI-based fMRI features, and whether MT learning provides an advantage over ST approaches.

To investigate these questions, this project uses the BIDS-formatted fMRI dataset of [1], [2], which was collected from participants performing the reinforcement learning task across six runs, with each run containing 120 trials (60 choice-based and 60 feedback-based). The imaging data is preprocessed with fMRIPrep, then reduced from voxel-based representations to region-of-interest (ROI)-level representations to make downstream modeling more computationally manageable and less vulnerable to overfitting. From these processed runs, choice-phase events were aligned with their corresponding learning targets, and BOLD activity was extracted after an appropriate hemodynamic response delay so that each event could be represented as a feature vector paired with a V or surprise label. This framing turns the problem into a supervised learning task in which neural activity is used to predict latent computational signals associated with learning from brain ROIs.

## Methods, Discussion, and Conclusions

To learn more about the subjects explored in this project please see the primary report: [here](https://github.com/Embra-Schuilenburg/machine-learning-mechanism-of-multisensory-learning/blob/master/an-exploration-of-machine-learning-for-neurocomputational-mechanisms-of-human-multisensory-learning.ipynb). ⠀⠀⠀

## References
[1] S. Bedi, E. Casimiro, G. de Hollander, N. Raduner, F. Helmchen, S. Brem, A. Konovalov, and C. C. Ruff, “Separable neurocomputational mechanisms underlying multisensory learning,” bioRxiv, 2026, doi: 10.1101/2025.11.18.688925.

[2] S. Bedi, E. Casimiro, G. de Hollander, N. Raduner, F. Helmchen, S. Brem, A. Konovalov, and C. C. Ruff, “Multisensory learning dataset,” OpenNeuro, ver. 1.0.0, 2026, doi: 10.18112/openneuro.ds007436.v1.0.0.

[3] A. Schaefer, R. Kong, E. M. Gordon, T. O. Laumann, X.-N. Zuo, A. J. Holmes, S. B. Eickhoff, and B. T. T. Yeo, “Local-Global Parcellation of the Human Cerebral Cortex from Intrinsic Functional Connectivity MRI,” Cerebral Cortex, vol. 28, no. 9, pp. 3095–3114, 2018, doi: 10.1093/cercor/bhx179.

[4] O. Esteban et al., “fMRIPrep: a robust preprocessing pipeline for functional MRI,” Nature Methods, vol. 16, no. 1, pp. 111–116, 2019, doi: 10.1038/s41592-018-0235-4.

[5] Nilearn contributors, nilearn [Software]. Zenodo, doi: 10.5281/zenodo.8397156.

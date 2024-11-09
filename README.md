# PhD

This repository includes my PhD thesis and the source code for generating the plots presented in the thesis.

## Thesis

The complete thesis, titled **"Compression models and tools for omics data"**, can be found in `thesis.pdf`.

### Abstract

The ever-increasing growth of the development of high-throughput sequencing technologies and as a consequence, generation of a huge volume of data, has revolutionized biological research and discovery. Motivated by that, we investigate in this thesis the methods which are capable of providing an ecient representation of omics data in compressed or encrypted manner, and then, we employ them to analyze omics data.

First and foremost, we describe a number of measures for the purpose of quantifying information in and between omics sequences. Then, we present finite-context models (FCMs), substitution-tolerant Markov models (STMMs) and a combination of the two, which are specialized in modeling biological data, in order for data compression and analysis.

To ease the storage of the aforementioned data deluge, we design two loss- less data compressors for genomic and one for proteomic data. The methods work on the basis of (a) a combination of FCMs and STMMs or (b) the mentioned combination along with repeat models and a competitive prediction model. Tested on various synthetic and real data showed their outperformance over the previously proposed methods in terms of compression ratio.

Privacy of genomic data is a topic that has been recently focused by developments in the field of personalized medicine. We propose a tool that is able to represent genomic data in a securely encrypted fashion, and at the same time, is able to compact FASTA and FASTQ sequences by a factor of three. It employs AES encryption accompanied by a shu✏ing mechanism for improving the data security. The results show it is faster than general-purpose and special-purpose algorithms.

Compression techniques can be employed for analysis of omics data. Having this in mind, we investigate the identification of unique regions in a species with respect to close species, that can give us an insight into evolutionary traits. For this purpose, we design two alignment-free tools that can accurately find and visualize distinct regions among two collections of DNA or protein sequences. Tested on modern humans with respect to Neanderthals, we found a number of absent regions in Neanderthals that may express new functionalities associated with evolution of modern humans.

Finally, we investigate the identification of genomic rearrangements, that have important roles in genetic disorders and cancer, by employing a compression technique. For this purpose, we design a tool that is able to accurately localize and visualize small- and large-scale rearrangements between two genomic sequences. The results of applying the proposed tool on several synthetic and real data conformed to the results partially reported by wet laboratory approaches, e.g., FISH analysis.

### Chapters

Here is the list of chapters in the thesis:

1. Introduction
2. Measures and models
3. Compression of omics data
4. Secure encryption of genomic data
5. Finding and visualization of distinct regions in omics sequences
6. Detection and visualization of genomic rearrangements
7. Conclusion

## Citation

If you find this work useful, please cite it as:

```
@phdthesis{hosseini2020compression,
  title={Compression Models and Tools for Omics Data},
  author={Hosseini, Seyedmorteza},
  year={2020},
  school={Universidade de Aveiro (Portugal)}
}
```

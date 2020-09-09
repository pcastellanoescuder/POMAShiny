
# Welcome to POMAShiny! <img src='pix/logo.png' align="right" height="139"/>

POMAShiny is an user-friendly web-based workflow for pre-processing and statistical analysis of mass spectrometry data. This tool allows you to analyze your data:

<b><span style="color:#f49338">Fast:</span></b> Analyze and visualize your data easily in few steps

<b><span style="color:#f49338">Friendly:</span></b> POMAShiny provides users a very intuitive structure and a whole interactive analysis

<b><span style="color:#f49338">Free:</span></b> All POMAShiny options are completely open and free for all users

<img src="pix/graphical_abstract.png" width="80%"/>

---

### Upload Data

  - Upload your data in the *"Upload Data"* tab
  - Data must be a CSV (*comma-separated-value*) file

**Target File**

A .CSV with two mandatory columns + *n* optional covariates:

  - Each row denotes a sample (the same as in the features file)
  - First/Left-hand column must be sample IDs => red
  - Second/Left-hand column must be sample group/factor (e.g. treatment) => green
  - Covariates (optional): From the third column (included) users can also include several experiment covariates => purple
  
<img src="pix/target.png" width="80%"/>

**Features File**

A .CSV with *m* columns:

  - Each row denotes a sample and each column denotes a feature
  - First row must contain the feature names

<img src="pix/features.png" width="80%" />

---

### More Help and Instructions

Additional help and more detailed instructions are provided in the "Help" panel. Furthermore, two different tutorials are provided in the "Tutorials" panel.    

---

### About POMAShiny

POMAShiny has been developed by Pol Castellano-Escuder, Raúl González-Domínguez, Cristina Andrés-Lacueva and Alex Sánchez-Pla at University of Barcelona, Spain.

The source code of POMAShiny is freely available on GitHub at https://github.com/pcastellanoescuder/POMAShiny.

We would appreciate reports of any issues with the app via the GitHub issue tracking at https://github.com/pcastellanoescuder/POMAShiny/issues.

---

<a href= 'https://sites.google.com/view/estbioinfo/home'><img src='pix/eib.gif' alt='EIB' title='Estadística i Bioinformàtica' width='160' height='40'/></a>
<a href= 'http://www.nutrimetabolomics.com/'><img src='pix/nutrimetabolomics.png' alt='NUTRIMETABOLOMICS' title='Nutrimetabolomics' width='160' height='40'/></a>
<a href= 'https://www.ciberfes.es'><img src='pix/ciberfes.png' alt='CIBERFESpng' title='CIBERFES' width='110' height='40'/></a>
<a href= 'https://www.ub.edu/web/ub/ca/'><img src='pix/ub.png' alt='UBpng' title='UB' width='160' height='40'/></a>


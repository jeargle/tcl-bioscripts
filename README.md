# tcl-bioscripts

Tcl scripts used within VMD for molecular modeling and MD trajectory analysis.

## AaPercentage

Take an selection string of protein residues and print a
list of percentages for the amino acid makeup of the set.

## ClosestAtoms

Compare atomSet1 to atomSet2 and produce a list of atoms
from atomSet2 that are closest to each atom of atomSet1.

## InsertNucleicResidue

Move two tRNA molecules together around the residue insert
location, move target residues (by the backbone) to template
positions, and add a new residue to the template insertion
position.

## IonResidence

Get times (ps) for ions residing near counter ions.  This
was developed for getting residence times of K and Na to
phosphates in the backbone of tRNA.

## MgSolvate

Fill out primary coordination (octahedral) hydration shell
for Mg ions.

## PdbRewrapBox

Recenter a water box around the system of interest and write
out pdb and psf files.

## Rotamer

Tools for setting the rotamer states of protein and nucleic
acid sidechains.

## SetFixedAtoms

Create fixed or constrained atom files used by NAMD.

## WaterBoxToSize

Create a water box with a set volume by padding each side
of the system by the same amount.

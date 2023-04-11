/*---------------------------------------------------------------------
**
**  Fichero:
**    fun_asm.asm  19/10/2022
**
**    (c) Daniel Báscones García
**    Fundamentos de Computadores II
**    Facultad de Informática. Universidad Complutense de Madrid
**
**  Propósito:
**    Fichero de código para la práctica 5_lab
**
**-------------------------------------------------------------------*/

.text

.extern matrix1
.extern matrix2
.global gameOfLife

gameOfLife:

	// Apilo la direccion de retorno
	addi sp, sp, 4
	sw ra, 0(sp)

	// Guardo los argumentos en registros preservados
	mv s1, a0 	// Matrix
	mv s2, a1	// mSize
	mv s3, a2	// neighborVector
	mv s4, a3	// nSize
	mv s11, a4	// resultMatrix pointer

	mv s5, zero	// i = 0
	fori:
		bge s5, s2, efori
		mv s6, zero // j = 0
		forj:
			bge s6, s2, eforj


			mv a0, s1 // Matrix pt
			mv a1, s2 // mSize
			mv a2, s3 // neigVector
			mv a3, s4 // nSize
			mv a4, s5 // i
			mv a5, s6 // j
			call countNeighbors
			mv s7, a0 	// neighborCount = countNeighbors()

			addi t0, zero, 1	// Guarda 1 para el if
			slli t1, s5, 2		// i * 4

			mv a0, t1			// Paso como primer argumento el numero a multiplicar
			mv a1, s2			// Multiplico i por mSize
			call mul
			mv t1, a0			// Guardo el resultado de i * mSize

			slli t2, s6, 2		// j * 4
			add t3, t1, t2		// Calculo el desplazamiento total
			add t4, s1, t3		// Sumo el desplazamiento al puntero base del vector
			lw t5, 0(t4)		// Saca el valor de matrix[i][j]

			add s10, s11, t3		// Calculo la direccion de returnMatrix[i][j]

			iflive: // if (matrix[i][j] == 1)
				bne t5, t0, elseiflive
				// Cell is alive
				ifneighlive: //if (neighborCount == 2 || neighborCount == 3)
					addi t1, zero, 2
					beq s7, t1, storeone // if == 2
					addi t1, zero, 3
					bne s7, t1, elseneighlive // if == 3
					storeone:
					addi t1, zero, 1
					sw t1, 0(s10)	// resultMatrix[i][j] = 1
					j eiflive
				elseneighlive:
					sw zero, 0(s10)	//  resultMatrix[i][j] = 0
					j eiflive
				eifneighlive:

			elseiflive:	// Cell is dead
				ifneighthree:
					addi t1, zero, 3
					bne s7, t1, elseifneighthree
					addi t1, zero, 1
					sw t1, 0(s10)	// resultMatrix[i][j] = 1
					j eifneighthree
				elseifneighthree:
					sw zero, 0(s10)	// resultMatrix[i][j] = 0
				eifneighthree:
			eiflive:

			addi s6, s6, 1	// j++
			j forj
		eforj:
		addi s5, s5, 1		// i++
		j fori
	efori:

	// Desapilo la direccion de retorno
	lw ra, 0(sp)
	addi sp, sp, -4

	mv a0, s11	// Devuelve la direccion de resultMatrix
	ret

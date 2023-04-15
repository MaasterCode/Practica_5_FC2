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
	mv s8, a4	// resultMatrix pointer

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
			mv s7, a0 			// neighborCount = countNeighbors()

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

			add s9, s8, t3		// Calculo la direccion de returnMatrix[i][j]

			iflive: 						// if (matrix[i][j] == 1)
				bne t5, t0, elseiflive
				// Cell is alive
				ifneighlive: 					//if (neighborCount == 2 || neighborCount == 3)
					addi t1, zero, 2
					beq s7, t1, storeone // if == 2
					addi t1, zero, 3
					bne s7, t1, elseneighlive // if == 3
					storeone:
					addi t1, zero, 1
					sw t1, 0(s9)	// resultMatrix[i][j] = 1
					j eiflive
				elseneighlive:
					sw zero, 0(s9)	//  resultMatrix[i][j] = 0
					j eiflive
				eifneighlive:

			elseiflive:
				// Cell is dead
				ifneighthree:
					addi t1, zero, 3
					bne s7, t1, elseifneighthree
					addi t1, zero, 1
					sw t1, 0(s9)	// resultMatrix[i][j] = 1
					j eifneighthree
				elseifneighthree:
					sw zero, 0(s9)	// resultMatrix[i][j] = 0
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

	mv a0, s8	// Devuelve la direccion de resultMatrix
	ret

countNeighbors:

	addi sp, sp, 40
	sw ra, 0(sp)	// Apilo ra
	sw s1, 4(sp)	// Apilo s1
	sw s2, 8(sp)	// Apilo s2
	sw s3, 12(sp)	// Apilo s3
	sw s4, 16(sp)	// Apilo s4
	sw s5, 20(sp)	// Apilo s5
	sw s6, 24(sp)	// Apilo s6
	sw s7, 28(sp)	// Apilo s7
	sw s8, 32(sp)	// Apilo s8
	sw s9, 36(sp)	// Apilo s9

	mv s1, zero // neighborCount
	mv s2, zero	// newi
	mv s3, zero	// newj
	mv s4, a4	// i
	mv s5, a5	// j
	mv s6, zero // k = 0

	mv s7, a0	// matrix dir
	mv s8, a1	// mSize
	mv s9, a2	// neighborVector dir
	mv s10, a3	// nSize

	forneighbor:
		bge s6, s10, eforneighbor // k < nSize
		slli t0, s6, 2			// k * 4 por los 4 bytes que ocupa

		slli t0, t0, 1			// k * 2 porque neighborVector tiene 2 de ancho

		add t0, s9, t0				// neighborVector + k * 4 * mSize

		lw t2, 0(t0)	// neighborVector[k][0]
		lw t3, 4(t0)	// neighborVector[k][1]
		add s2, t2, s4	// newi += i
		add s3, t3, s5  // newj += j

		ifInsideBorder: // newi > -1 && newi < mSize && newj > -1 && newj < mSize
			add t1, zero, -1
			bge t1, s2, eifInsideBorder	// newi > -1
			bge t1, s3, eifInsideBorder	// newj > -1
			bge s2, s8, eifInsideBorder // newi < mSize
			bge s3, s8, eifInsideBorder // newj < mSize

			ifNeighborAlive:
				slli t0, s2, 2			// newi * 4
				slli t1, s3, 2			// newj * 4

				mv a0, t0				// Pasa newi*4 para multiplicar
				mv a1, s8				// Multiplica por mSize la k
				call mul
				add t2, a0, t1			// Desplazamiento total para matrix[newi][newj]
				add t2, t2, s7			// Matrix + desplazamiento
				lw t2, 0(t2)			// matrix[newi][newj]

				addi t1, zero, 1
				bne t2, t1, eifNeighborAlive // if (matrix[newi][newj] == 1)

				addi s1, s1, 1			// neighborCount++
			eifNeighborAlive:
		eifInsideBorder:

		addi s6, s6, 1 	// k++
		j forneighbor
	eforneighbor:

	mv a0, s1		// Devuelvo neighborCount

	lw ra, 0(sp)	// Despilo ra
	lw s1, 4(sp)	// Despilo s1
	lw s2, 8(sp)	// Despilo s2
	lw s3, 12(sp)	// Despilo s3
	lw s4, 16(sp)	// Despilo s4
	lw s5, 20(sp)	// Despilo s5
	lw s6, 24(sp)	// Despilo s6
	lw s7, 28(sp)	// Despilo s7
	lw s8, 32(sp)	// Despilo s8
	lw s9, 36(sp)	// Despilo s9
	addi sp, sp, -40

			// Devuelve neighborCount
	ret

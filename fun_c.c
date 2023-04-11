/*---------------------------------------------------------------------
 **
 **  Fichero:
 **    fun_c.c  19/10/2022
 **
 **    (c) Daniel Báscones García
 **    Fundamentos de Computadores II
 **    Facultad de Informática. Universidad Complutense de Madrid
 **
 **  Propósito:
 **    Fichero de código para la práctica 5_lab
 **
 **-------------------------------------------------------------------*/

// There are 8 squares surrounding any square
const int nSize = 8;
const int mSize = 5;
int neighborsVectors[8][2] = {
		{ -1, -1 }, { -1, 0 }, { -1, 1 },
		{ 0, -1 }, { 0, 1 },
		{ 1, -1 }, { 1, 0 }, { 1, 1 },
};
int (*neighborPointer)[2] = neighborsVectors;

int matrix1[5][5] = {
		{0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0},
		{0, 0, 1, 1, 0},
		{0, 0, 1, 0, 0},
		{0, 0, 0, 0, 0},
};

/*
 * Esperado matriz 1
 *  {0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0},
	{0, 0, 1, 1, 0},
	{0, 0, 1, 1, 0},
	{0, 0, 0, 0, 0},
 */

int matrix2[5][5] = {
		{0, 0, 0, 0, 0},
		{0, 0, 1, 1, 0},
		{0, 0, 1, 0, 1},
		{0, 0, 1, 0, 0},
		{0, 0, 0, 0, 0},
};

/*
 * Esperado matriz 2
 *  {0, 0, 0, 0, 0},
	{0, 0, 1, 1, 0},
	{0, 1, 1, 0, 0},
	{0, 0, 0, 1, 0},
	{0, 0, 0, 0, 0},
 */

int (*playing_matrix)[5] = matrix1;

int resultMatrix[5][5] = {
		{0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0},
	};
extern int ** gameOfLife(int matrix[][5],  int mSize, int neighborVector[][2], int nSize, int resMatrix[][5]);
/*
int ** gameOfLife(int matrix[][5], int mSize, int neighborVector[][2], int nSize, int resultMatrix[][5]) {
// Check neighbors
	int neighborCount;
	int newi;
	int newj;

	for (int i = 0; i < mSize ; i++) {
		for (int j = 0; j < mSize; j++) {

			neighborCount = countNeighbors(matrix, mSize, neighborVector, nSize, i, j);

			if (matrix[i][j] == 1) {
			// If cell is alive

				// If alone or overpopulation, cell dies
				if (neighborCount == 2 || neighborCount == 3) {
					resultMatrix[i][j] = 1;
				} else {
					resultMatrix[i][j] = 0;
				}

			} else {
			// If cell is dead
				// If three neighbors, a new cell is born
				if (neighborCount == 3) {
					resultMatrix[i][j] = 1;
				} else {
					resultMatrix[i][j] = 0;
				}
			}
		}
	}
	return resultMatrix;
};
*/
int countNeighbors(int matrix[][5], int mSize, int neighborVector[][2], int nSize, int i, int j) {
	int neighborCount = 0;
	int newi;
	int newj;

	for (int k = 0; k < nSize; k++) {
		newi = i + neighborVector[k][0];
		newj = j + neighborVector[k][1];
		if (newi > -1 && newi < mSize && newj > -1 && newj < mSize) {
			if (matrix[newi][newj] == 1) {
				neighborCount++;
			}
		}
	}

	return neighborCount;
}

int mul(int a, int x) {
	return a * x;
}

void main() {

	int **respointer;
	respointer = gameOfLife(playing_matrix, mSize, neighborPointer, nSize, resultMatrix);
	while(1);
}

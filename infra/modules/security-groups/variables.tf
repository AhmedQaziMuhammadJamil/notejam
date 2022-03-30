variable "vpc_id" {
  type = string
}

variable "env" {
}


variable "alb-sg-name" {
    type= string
    default = "NoteJam-Alb-SG"
}

variable "worker-sg-name" {
    type= string
    default = "Worker-Node-SG"
}

variable "alb-sg" {
  default = {
    NoteJam-Alb-SG = {
      rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          description = "HTTP-Port"
          cidr_blocks = ["0.0.0.0/0"]
        },

        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "HTTPS-Port"
          cidr_blocks = ["0.0.0.0/0"]
        },

      ],
    }

  }


}
variable "worker-node-sg" {
  default = {
    NoteJam-Worker-SG = {
      rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          description = "HTTP-Port-from-ALB"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          description = "HTTPS-Port-from-ALB"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ],
    }

  }


}

variable "rds-sg" {
  default = {
     NoteJam-RDS-SG = {
      rules = [{
        from_port   = 3306
        to_port     = 3306
        description = "Allow Access from Ec2 "
        protocol    = "tcp"

        }
      ],
    }
  }


}



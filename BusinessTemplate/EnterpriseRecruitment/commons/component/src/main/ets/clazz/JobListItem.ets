export class JobListItem {
  id: string
  recruitmentTag: number
  name: string
  address: number
  jobType: string
  publishTime: string
  recruitmentType: number
  responsibilities: string
  requirements: string

  constructor(id: string, recruitmentTag: number, name: string, address: number, jobType: string,
    publishTime: string, recruitmentType: number, responsibilities: string, requirements: string) {
    this.id = id;
    this.recruitmentTag = recruitmentTag;
    this.name = name;
    this.address = address;
    this.jobType = jobType;
    this.publishTime = publishTime;
    this.recruitmentType = recruitmentType;
    this.responsibilities = responsibilities;
    this.requirements = requirements;
  }
}